function doGet() {
  
  var cache = CacheService.getPublicCache();
  var cacheKey = "inbox-stats.v1";
  var result = cache.get(cacheKey);

  // Cache the result to stay within the Apps Script quota
  if (!result) {
    var numThreads = 0;
    var totalAge = 0;
  
    threads = GmailApp.getInboxThreads();
    numThreads = threads.length;
    for (var i = 0; i < threads.length; i++) {

      ageMillis = Date.now() - threads[i].getLastMessageDate();
      ageDays = ageMillis / (24.0 * 3600.0 * 1000.0)
      totalAge += ageDays;
    }
    
    avgDays = Math.round(totalAge/numThreads);

    resultObj = {"numThreads": numThreads,
              "avgDays": avgDays};
    result = JSON.stringify(resultObj)

    // Cache for 20 minutes
    cache.put(cacheKey, result, 1200); 
  }

  return ContentService.createTextOutput(result)
     .setMimeType(ContentService.MimeType.JSON);  
}
