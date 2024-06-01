# WebCrawler

This project is a simple implementation of an API server for scraping and parsing data.
It is created based on the requirements described in the [task file](./TASK.md).

## Setup

* `git clone https://github.com/FlintOFF/web_crawler.git`
* `bundle install`
* install and start the Redis server
  * `brew install redis`
  * `brew services start redis`

## Run server

`bundle exec rails s`

## Test

`rspec`

## Examples

### /data

#### Request

`url = http://127.0.0.1:3000/data`

```json
{
    "url": "https://www.alza.cz/aeg-7000-prosteam-lfr73964cc-d7635493.htm",
    "fields": {
        "rating_count": ".ratingCount",
        "rating_value": ".ratingValue",
        "meta": ["keywords", "twitter:image"]
    }
}
```

#### Response

```json
{
    "rating_count": "8 hodnocení",
    "rating_value": "4,9",
    "meta": {
        "keywords": "AEG,7000,ProSteam®,LFR73964CC,Automatické pračky,Automatické pračky AEG,Chytré pračky,Chytré pračky AEG",
        "twitter:image": "https://image.alza.cz/products/AEGPR065/AEGPR065.jpg?width=360&height=360"
    }
}
```

### /v2/data

#### Request

`url = http://127.0.0.1:3000/v2/data`

```json
{
  "url": "https://www.alza.cz/aeg-7000-prosteam-lfr73964cc-d7635493.htm",
  "fields": [
    { "name": "rating_count", "selector": ".ratingCount" },
    { "name": "rating_value", "selector": "//*[@class='ratingValue'][1]/text()", "selector_kind": "xpath" },
    { "name": "meta_keywords", "selector": "//meta[@name='keywords'][1]/@content", "selector_kind": "xpath" },
    { "name": "meta_twitter_image", "selector": "//meta[@name='twitter:image'][1]/@content", "selector_kind": "xpath" }
  ],
  "meta": ["keywords", "twitter:image"]
}
```

#### Response

```json
{
  "rating_count": "8 hodnocení",
  "rating_value": "4,9",
  "meta_keywords": "AEG,7000,ProSteam®,LFR73964CC,Automatické pračky,Automatické pračky AEG,Chytré pračky,Chytré pračky AEG",
  "meta_twitter_image": "https://image.alza.cz/products/AEGPR065/AEGPR065.jpg?width=360&height=360",
  "meta": {
    "keywords": "AEG,7000,ProSteam®,LFR73964CC,Automatické pračky,Automatické pračky AEG,Chytré pračky,Chytré pračky AEG",
    "twitter:image": "https://image.alza.cz/products/AEGPR065/AEGPR065.jpg?width=360&height=360"
  }
}
```

## TODO

- Add [VCR](https://github.com/vcr/vcr)
