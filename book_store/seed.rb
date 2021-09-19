require "sqlite3"
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

  # books
  BOOK_COUNT = 200
  BOOK_COUNT.times.map {|i|
  <<~SQL
    (#{i + 1}, #{rand(3) + 1}, "#{FFaker::Book.title}", "#{fake_timestamp}", #{rand(1000) + 100})
  SQL
  }.join(',').tap do |data|
    db.execute <<~SQL
      insert into
        books (id, book_kind_id, title, publication_date, page_count)
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
  BOOK_COUNT.times.map {|i|
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
  (BOOK_COUNT / 2).times.map {|i|
  <<~SQL
    (#{i + 1 + BOOK_COUNT}, #{rand(AUTHORS_COUNT) + 1}, #{i + 1}, '')
  SQL
  }.join(',').tap do |data|
    db.execute <<~SQL
      insert into
        authors_books(id, author_id, book_id, role)
      values
      #{data}
    SQL
  end

  # publishers
  BOOK_COUNT.times.map {|i|
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

  # book_images
  (BOOK_COUNT / 2).times.map {|i|
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
  (BOOK_COUNT / 2).times.map {|i|
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


end
