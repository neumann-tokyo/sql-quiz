# Sales difference

## Database

* https://github.com/neumann-tokyo/sql-quiz/blob/main/store/store.db
* https://github.com/neumann-tokyo/sql-quiz/blob/main/store/init-db.sql

## English

There is a `reports` table which has weekly sales of a coffee shop.
For each product, output `/` if weekly sales are increasing, `\` if it is decreasing, and `-` if it is flat.
If you cannot get the sales of last week, it will be set to 0.

## Japanese

コーヒーショップの週毎の売上をまとめた reports テーブルがあります。
各商品について週毎の売上が増加している場合 `/` 、減少している場合 `\` 、横ばいの場合 `-` を出力してください。
なお先週の売り上げを取得できない場合 0 とします。

## Output Example

| item_name  | weeknum | lastweek_price | price | mark |
|------------|---------|----------------|-------|------|
| Brazil     | 1       | 0              | 52182 | /    |
| Brazil     | 2       | 52182          | 26551 | \    |
| Brazil     | 3       | 26551          | 67126 | /    |
| Brazil     | 4       | 67126          | 80713 | /    |
| Guatemala  | 1       | 0              | 52030 | /    |
| Guatemala  | 2       | 52030          | 84293 | /    |
| Guatemala  | 3       | 84293          | 40253 | \    |
| Guatemala  | 4       | 40253          | 50824 | /    |
| Kenya      | 1       | 0              | 89655 | /    |
| Kenya      | 2       | 89655          | 88429 | \    |
| Kenya      | 3       | 88429          | 95173 | /    |
| Kenya      | 4       | 95173          | 11806 | \    |
| Mandheling | 1       | 0              | 36333 | /    |
| Mandheling | 2       | 36333          | 36333 | -    |
| Mandheling | 3       | 36333          | 84776 | /    |
| Mandheling | 4       | 84776          | 95251 | /    |
