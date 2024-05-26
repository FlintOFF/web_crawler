# Task

I have the option to use the Scraper to expand my data with new fields. 
The goal of the task is to create a standalone Rails application with a simple interface for the scraper. 
It should receive a URL address and a list of fields to extract from webpage on given URL address in the request.

## Task #1

Basic behavior of the scraper, i.e., using simple CSS selectors.

### Request:

GET /data
JSON params:

```json
{
  "url": "https://www.alza.cz/aeg-7000-prosteam-lfr73964cc-d7635493.htm",
  "fields": {
    "price": ".price-box__price",
    "rating_count": ".ratingCount",
    "rating_value": ".ratingValue"
  }
}
```

### Response:

```json
{
  "price": "18290,-",
  "rating_value": "4,9",
  "rating_count": "7 hodnocení"
}
```

## Task #2

Expanding functionality with meta information from the page. 
As part of the request, add "meta" to the fields where the array contains the "name" of individual meta tags.

### Request:

```json
{
  "url": "https://www.alza.cz/aeg-7000-prosteam-lfr73964cc-d7635493.htm",
  "fields": {
    "meta": [
      "keywords",
      "twitter:image"
    ]
  }
}
```

### Response:

```json
{
  "meta": {
    "keywords": "Parní pračka AEG 7000 ProSteam® LFR73964CC na www.alza.cz.✅Bezpečný nákup.✅ Veškeré informace o produktu.✅ Vhodné příslušenství.✅ Hodnocenía recenze AEG...",
    "twitter:image": "https//image.alza.cz/products/AEGPR065/AEGPR065.jpg?width=360&height=360"
  }
}
```

## Task #3

Consider optimization and caching for individual downloads. 
The same request to the URL may come multiple times with requests for different fields.
The solution should also include tests. 
Please provide the result on GitHub and send the link to the repository.
Thank you for the effort and time you put into this task. We appreciate it a lot!

## Task #4

Consider how the application could evolve over time, identify its weaknesses, and find areas for acceleration and parallelism.