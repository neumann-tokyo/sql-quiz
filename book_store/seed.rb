require "sqlite3"
require 'ffaker'

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
  BOOK_COUNT.times {|i|
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
  (BOOK_COUNT / 2).times {|i|
  <<~SQL
    (#{i + BOOK_COUNT}, #{rand(AUTHORS_COUNT) + 1}, #{i + 1}, '')
  SQL
  }.join(',').tap do |data|
    db.execute <<~SQL
      insert into
        authors_books(id, author_id, book_id, role)
      values
      #{data}
    SQL
  end


end
