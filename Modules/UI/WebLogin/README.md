
# Authentication

This section is an overview of how the authentication works.

To use the Teamwork API you need 
- Your company name
- An API key or an access token

The company name is in the subdomain of the URL when you access your Teamwork installation. For instance, if your URL is `https://stnicholashospital.teamwork.com/`, then your company name is `stnicholashospital`.

## How to get an API key

1. Log to your project using the details provided in the specification page.
2. Go to your profile (top, right), and click on “Edit My Details”.
3. Go to the tab API & Mobile. Click Show your Token. For me, it was twp_k9ejP88LcuojHjmFkUFuYIUNYalg (yours will be different).

## How to get an access token

1. Register your application to handle an arbitrary scheme. For instance, stnicholashospitalapp.

2. Make up a “custom callback“ URL with format `customprotocolapp` + `://` + `callback`. For our example, `stnicholashospitalapp://callback`. Actually, the `callback` suffix can be anything, it doesn’t really matter what you write there.

3. Open https://www.teamwork.com/launchpad/login?redirect_uri=stnicholashospitalapp://callback in a webview. Replace the custom callback at the end with yours.

4. Fill the login and password in the form that appears.

5. The last authentication page has an “Allow” button that invokes your custom callback. The URL will be similar to this:
```
stnicholashospitalapp://callback?code=3e3a3c71-3484-589d-bdfd-a98283a5d2eb
```

6. When the browser tries to load the custom URL, it asks the system to launch the application able to handle it. The system will ask whether you wish to load the application. Press yes to receive the custom URL in your application. At this point you should parse the value of the `code` query item.

7. Once you have the code, run the following query

  | Component | Value |
  |---|---|
  | URL | `https://www.teamwork.com/launchpad/v1/token.json` |
  | Method | `POST` |
  | Body | `{"code":"3e3a3c71-3484-589d-bdfd-a98283a5d2eb"}` |
  | Header | `Accept: application/json` |
  | Header | `Content-Type: application/json` |

Or, if you are a curl aficionado:
```
curl -s -X POST -H "Accept: application/json" -H "Content-Type: application/json" -d '{"code":"3e3a3c71-3484-589d-bdfd-a98283a5d2eb"}' https://www.teamwork.com/launchpad/v1/token.json | python -mjson.tool
```

## Curl

Send login and password
```bash
curl 'https://testingtheiosappwithanemptyprojectinc.eu.teamwork.com/launchpad/v1/login.json' \
-X POST \
-H 'Referer: https://testingtheiosappwithanemptyprojectinc.eu.teamwork.com/launchpad/login/projects' \
-H 'Accept: application/json, text/plain, */*' \
-H 'Content-Type: application/json;charset=UTF-8' \
-d '{"username":"alejandro.ramirez@teamwork.com","email":"alejandro.ramirez@teamwork.com","password":"p4ssw0rd","rememberMe":false}'
```

Response will be
```json
{
    "gdprSeen": true,
    "installation": {
        "id": 588434,
        "apiEndPoint": "https://testingtheiosappwithanemptyprojectinc.eu.teamwork.com/",
        "region": "EU",
        "url": "https://testingtheiosappwithanemptyprojectinc.eu.teamwork.com/",
        "company": {
            "id": 150787,
            "name": "Beforeigners",
            "logo": ""
        },
        "logo": "",
        "name": "Testing the iOS App with an empty project Inc.",
        "projectsEnabled": true,
        "deskEnabled": false,
        "chatEnabled": false
    },
    "status": "ok",
    "userId": 471466,
    "usernameInfo": {
        "username": "alejandro.ramirez@teamwork.com",
        "hasChanged": false
    }
}
```

Trade the authorization code for an access token
```bash
curl 'https://www.teamwork.com/launchpad/v1/token.json' \
-s \
-X POST \
-H "Accept: application/json"  \
-H "Content-Type: application/json"  \
-d '{"code":"3e3a3c71-3484-589d-bdfd-a98283a5d2eb"}'  \
 | python -mjson.tool
```
