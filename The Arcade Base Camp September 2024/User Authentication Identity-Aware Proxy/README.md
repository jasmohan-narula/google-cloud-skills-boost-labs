# User Authentication: Identity-Aware Proxy

GSP499

https://www.cloudskillsboost.google/games/5425/labs/35159


Follow the steps from the labs.

I've just saved the final application which does the IAP verification using header X-Goog-IAP-JWT-Assertion



## Notes
There are two lines in main.py that get the IAP-provided identity data:
```
user_email = request.headers.get('X-Goog-Authenticated-User-Email')
user_id = request.headers.get('X-Goog-Authenticated-User-ID')
```
The X-Goog-Authenticated-User- headers are provided by IAP, and the names are case-insensitive, so they could be given in all lower or all upper case if preferred.


## Task 3. Use Cryptographic Verification
```
cd ~/user-authentication-with-iap/3-HelloVerifiedUser
gcloud app deploy
gcloud app browse
```
