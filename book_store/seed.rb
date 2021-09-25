require 'sqlite3'
require 'ffaker'
require 'securerandom'

def fake_timestamp
  FFaker::Time.datetime.strftime("%FT%T.%3N")
end

# Open a database
database = SQLite3::Database.new("book_store.db")

database.transaction do |db|
  # book_kinds
  db.execute <<~SQL
    insert into
      book_kinds (id, name)
    values
      (1, "novel")
      ,(2, "comic")
      ,(3, "paperback")
      ,(4, "picture book")
    ;
  SQL

  # publishers
  PUBLISHER_COUNT = 50
  PUBLISHER_COUNT.times.map {|i|
  <<~SQL
    (#{i + 1}, "#{FFaker::Name.first_name}")
  SQL
  }.join(',').tap do |data|
    db.execute <<~SQL
      insert into
        publishers (id, name)
      values
        #{data}
      ;
    SQL
  end

  # books
  BOOKS_COUNT = 200
  BOOKS_COUNT.times.map {|i|
  <<~SQL
    (
      #{i + 1},
      #{rand(1..4)},
      #{rand(1..PUBLISHER_COUNT)},
      "#{FFaker::Book.title}",
      "#{fake_timestamp}",
      #{rand(100..1000)},
      #{rand(200..10000)},
      0.10
    )
  SQL
  }.join(',').tap do |data|
    db.execute <<~SQL
      insert into
        books (id, book_kind_id, publisher_id, title, publication_date, page_count, price, tax)
      values
        #{data}
      ;
    SQL
  end

  # authors
  AUTHORS_COUNT = 200
  AUTHORS_COUNT.times.map {|i|
  <<~SQL
    (#{i + 1}, "#{FFaker::Name.name}")
  SQL
  }.join(',').tap do |data|
    db.execute <<~SQL
      insert into
        authors (id, name)
      values
        #{data}
    SQL
  end

  # authors_books
  BOOKS_COUNT.times.map {|i|
  <<~SQL
    (#{i + 1}, #{rand(AUTHORS_COUNT) + 1}, #{i + 1}, '')
  SQL
  }.join(',').tap do |data|
    db.execute <<~SQL
      insert into
        authors_books(id, author_id, book_id, role)
      values
      #{data}
    SQL
  end
  (BOOKS_COUNT / 2).times.map {|i|
  <<~SQL
    (#{i + 1 + BOOKS_COUNT}, #{rand(AUTHORS_COUNT) + 1}, #{i + 1}, '')
  SQL
  }.join(',').tap do |data|
    db.execute <<~SQL
      insert into
        authors_books(id, author_id, book_id, role)
      values
      #{data}
    SQL
  end

  # book_images
  (BOOKS_COUNT / 2).times.map {|i|
    uuid = SecureRandom.uuid
    <<~SQL
      (#{i + 1}, "#{uuid}.jpg", "http://www.example.com/#{uuid}.jpg")
    SQL
  }.join(',').tap do |data|
    db.execute <<~SQL
      insert into
        book_images (id, name, url)
      values
        #{data}
      ;
    SQL
  end

  # book_iamges_books
  (BOOKS_COUNT / 2).times.map {|i|
    uuid = SecureRandom.uuid
    <<~SQL
      (#{i + 1}, #{i + 1}, #{i + 1}, #{i + 1})
    SQL
  }.join(',').tap do |data|
    db.execute <<~SQL
      insert into
        book_images_books (id, book_image_id, book_id, display_order)
      values
        #{data}
      ;
    SQL
  end

  # customers
  CUSTOMERS_COUNT = 1000
  CUSTOMERS_COUNT.times.map {|i|
    <<~SQL
      (#{i + 1}, "#{FFaker::Name.last_name}", "#{FFaker::Name.first_name}", #{i + 1}, "#{FFaker::Internet.email}", "#{SecureRandom.hex(20)}")
    SQL
  }.join(',').tap do |data|
    db.execute <<~SQL
      insert into
        customers (id, family_name, given_name, display_name, email, password_digest)
      values
        #{data}
      ;
    SQL
  end

  # customer_addresses
  CUSTOMERS_COUNT.times.map {|i|
    <<~SQL
      (#{i + 1},
        #{i + 1},
        "#{FFaker::AddressUS.street_address}",
        "#{FFaker::Address.city}",
        "#{FFaker::AddressUS.state}",
        "#{FFaker::Address.country}",
        "#{FFaker::AddressUS.zip_code}",
        "#{FFaker::PhoneNumber.short_phone_number}",
        #{i.even? ? true : false}
      )
    SQL
  }.join(',').tap do |data|
    db.execute <<~SQL
      insert into
        customer_addresses (id, customer_id, address, city, state, country, postal_code, phone, default_address)
      values
        #{data}
      ;
    SQL
  end

  # purchases
  PURCHASES_COUNT = 10000
  PURCHASES_COUNT.times.map {|i|
    <<~SQL
      (
        #{i + 1},
        #{rand(1..CUSTOMERS_COUNT)},
        0,
        0.10
      )
    SQL
  }.join(',').tap do |data|
    db.execute <<~SQL
      insert into
        purchases (id, customer_id, sum_price, tax)
      values
        #{data}
      ;
    SQL
  end

  # purchases_books
  index = 1
  while (index <= PURCHASES_COUNT) do
    purchase_id = index
    books = db.execute(<<~SQL)
      select
        id, price, tax
      from
        books
      order by random()
      limit #{rand(1..10)}
    SQL

    books.each do |book|
      db.execute(<<~SQL)
        insert into
          purchases_books (id, purchase_id, book_id, price, tax)
        values
          (
            #{index},
            #{purchase_id},
            #{book[0]},
            #{book[1]},
            #{book[2]}
          )
        ;
      SQL
      index += 1
    end

    sum_price = books.map {|book| book[1] }.sum
    db.execute(<<~SQL)
      update purchases
      set sum_price = #{sum_price}
      where id = #{purchase_id};
    SQL
  end

  db.execute(<<~SQL)
    delete from purchases where sum_price = 0;
  SQL

  # reviews
  REVIEWS_COUNT = 10000
  REVIEWS_COUNT.times.map {|i|
    <<~SQL
      (
        #{i + 1},
        #{rand(1..BOOKS_COUNT)},
        #{rand(1..CUSTOMERS_COUNT)},
        #{rand(1..5)},
        "#{FFaker::Lorem.paragraphs.join(' ')}"
      )
    SQL
  }.join(',').tap do |data|
    db.execute <<~SQL
      insert into
        reviews (id, book_id, customer_id, point, comment)
      values
        #{data}
      ;
    SQL
  end
end
