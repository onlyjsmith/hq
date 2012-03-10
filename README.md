# Getting this up and running

## PostGIS
Need to enable PostGIS on both `hq_dev` and `hq_test` (so need to run the following for *each*).

`psql -d hq_dev -f /usr/local/Cellar/postgresql/9.1.2/share/postgresql/contrib/postgis-2.0/postgis.sql`
`psql -d hq_dev -f /usr/local/Cellar/postgresql/9.1.2/share/postgresql/contrib/postgis-2.0/spatial_ref_sys.sql`
           
## CartoDB

You'll need to create a cartodb_config.yml file and place it into config directory:
  host: '<your cartodb host>'
  oauth_key: 'oauthkey'
  oauth_secret: 'oauthsecret'
  username: 'username'
  password: 'password'