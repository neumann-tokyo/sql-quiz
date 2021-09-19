create table book_kinds(
  id integer primary key not null
  ,name varchar(500) not null
  ,created_at timestamp default (datetime('now', 'localtime')) not null
  ,updated_at timestamp default (datetime('now', 'localtime')) not null
);

create table books(
  id integer primary key not null
  ,book_kind_id integer not null
  ,title varchar(500) not null
  ,publication_date timestamp not null
  ,page_count integer
  ,created_at timestamp default (datetime('now', 'localtime')) not null
  ,updated_at timestamp default (datetime('now', 'localtime')) not null

  ,FOREIGN KEY(book_kind_id) REFERENCES books(id)
);

create table authors(
  id integer primary key not null
  ,name varchar(500) not null
  ,created_at timestamp default (datetime('now', 'localtime')) not null
  ,updated_at timestamp default (datetime('now', 'localtime')) not null
);

create table authors_books(
  id integer primary key not null
  ,author_id integer not null
  ,book_id integer not null
  ,role varchar(50) not null
  ,created_at timestamp default (datetime('now', 'localtime')) not null
  ,updated_at timestamp default (datetime('now', 'localtime')) not null

  ,FOREIGN KEY(author_id) REFERENCES authors(id)
  ,FOREIGN KEY(book_id) REFERENCES books(id)
);

create table publishers(
  id integer primary key not null
  ,name varchar(500) not null
  ,created_at timestamp default (datetime('now', 'localtime')) not null
  ,updated_at timestamp default (datetime('now', 'localtime')) not null
);

create table book_images(
  id integer primary key not null
  ,name varchar(500) not null
  ,url varchar(500) not null
  ,created_at timestamp default (datetime('now', 'localtime')) not null
  ,updated_at timestamp default (datetime('now', 'localtime')) not null
);

create table book_images_books(
  id integer primary key not null
  ,book_image_id integer not null
  ,book_id integer not null
  ,display_order integer not null
  ,created_at timestamp default (datetime('now', 'localtime')) not null
  ,updated_at timestamp default (datetime('now', 'localtime')) not null

  ,FOREIGN KEY(book_image_id) REFERENCES book_images(id)
  ,FOREIGN KEY(book_id) REFERENCES books(id)
);

create table customers(
  id integer primary key not null
  ,family_name varchar(100) not null
  ,given_name varchar(100) not null
  ,display_name varchar(25) not null
  ,email varchar(100) not null
  ,password_digest varchar(500) not null
  ,created_at timestamp default (datetime('now', 'localtime')) not null
  ,updated_at timestamp default (datetime('now', 'localtime')) not null
);

create table customer_addresses(
  id integer primary key not null
  ,customer_id integer not null
  ,address varchar(100) not null
  ,city varchar(100) not null
  ,state varchar(100) not null
  ,country varchar(100) not null
  ,postal_code varchar(10) not null
  ,phone varchar(20) not null
  ,default_address boolean not null default (false)
  ,created_at timestamp default (datetime('now', 'localtime')) not null
  ,updated_at timestamp default (datetime('now', 'localtime')) not null

  ,FOREIGN KEY(customer_id) REFERENCES customers(id)
);

create table purchases(
  id integer primary key not null
  ,customer_id integer not null
  ,sum_price integer not null
  ,tax real not null
  ,postage integer not null
  ,created_at timestamp default (datetime('now', 'localtime')) not null
  ,updated_at timestamp default (datetime('now', 'localtime')) not null

  ,FOREIGN KEY(customer_id) REFERENCES customers(id)
);

create table purchases_books(
  id integer primary key not null
  ,purchase_id integer not null
  ,book_id integer not null
  ,price integer not null
  ,tax real not null
  ,created_at timestamp default (datetime('now', 'localtime')) not null
  ,updated_at timestamp default (datetime('now', 'localtime')) not null

  ,FOREIGN KEY(purchase_id) REFERENCES purchases(id)
  ,FOREIGN KEY(book_id) REFERENCES books(id)
);

create table reviews(
  id integer primary key not null
  ,book_id integer not null
  ,customer_id integer not null
  ,point integer not null
  ,comment text not null
  ,created_at timestamp default (datetime('now', 'localtime')) not null
  ,updated_at timestamp default (datetime('now', 'localtime')) not null

  ,FOREIGN KEY(customer_id) REFERENCES customers(id)
  ,FOREIGN KEY(book_id) REFERENCES books(id)
);
