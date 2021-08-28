create table books(
  id integer primary key
  ,title varchar(500)
  ,publication_date timestamp
  ,gape_count integer
  ,isbn_10 varchar(10)
  ,isbn_13 varchar(14)
  ,created_at timestamp default (datetime('now', 'localtime'))
  ,updated_at timestamp default (datetime('now', 'localtime'))
);

