gcloud functions deploy sendNotification --project=swacch-kabadi \
  --entry-point sendNotification \
  --runtime nodejs18 \
  --trigger-topic user-notifications \
  --region asia-south1 \
  --allow-unauthenticated \
 


