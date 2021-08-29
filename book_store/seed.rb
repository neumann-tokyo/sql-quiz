require "sqlite3"
require 'ffaker'

def fake_timestamp
  FFaker::Time.datetime.strftime("%FT%T.%3N")
end

# Open a database
database = SQLite3::Database.new("book_store.db")

database.transaction do |db|
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

  data = 200.times.map {|i|
  <<~SQL
    (#{i}, #{rand(3) + 1}, "#{FFaker::Book.title}", "#{fake_timestamp}", #{rand(1000) + 100})
  SQL
  }.join(',')
  db.execute <<~SQL
    insert into
      books (id, book_kind_id, title, publication_date, page_count)
    values
      #{data}
    ;
  SQL
end


