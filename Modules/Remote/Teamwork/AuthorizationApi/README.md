# AuthorizationApi

## Login/pass authorization flow

Get domain
```
curl 'https://www.teamwork.com/launchpad/v1/accounts.json?generic=true' \
-X POST \
-H 'Accept: application/json, text/plain, */*' \
-H 'Content-Type: application/json;charset=UTF-8' \
-d '{"username":"alejandro.ramirez@teamwork.com","email":"alejandro.ramirez@teamwork.com","password":"p4ssw0rd","rememberMe":false}'
```

```
{
    "accounts": [
        {
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
            "user": {
                "id": 471466,
                "firstName": "Alejandro",
                "lastName": "Ramirez",
                "email": "alejandro.ramirez@teamwork.com",
                "avatar": "https://s3-eu-west-1.amazonaws.com/tw-eu-files/588434/userAvatar/twia_fd233d46c8c9c58722aa81a3b0885849.png",
                "company": {
                    "id": 150787,
                    "name": "Beforeigners",
                    "logo": "https://s3-eu-west-1.amazonaws.com/tw-eu-files/"
                }
            }
        }
    ],
    "status": "ok"
}
```


Get authentication code

```
curl https://testingtheiosappwithanemptyprojectinc.eu.teamwork.com/launchpad/v1/login.json?appAuth=true \
-X POST \
-H 'Accept: application/json, text/plain, */*' \
-H 'Content-Type: application/json;charset=UTF-8' \
-d '{"username":"alejandro.ramirez@teamwork.com","email":"alejandro.ramirez@teamwork.com","password":"p4ssw0rd","rememberMe":false}'
```

```
{
    "app": {
        "id": 0,
        "ownerId": 0,
        "code": "",
        "clientId": "",
        "scope": [
            "projects",
            "desk",
            "chat",
            "crm",
            "spaces"
        ],
        "name": "",
        "logo": "",
        "url": "",
        "dateCreated": null,
        "dateUpdated": null,
        "isValidated": true,
        "consentRequired": true
    },
    "code": "e0035223-44dc-4146-9322-4001a56e0417",
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
        "username": "",
        "hasChanged": false
    }
}
```

Get access token

```
curl https://www.teamwork.com/launchpad/v1/token.json \
-v \
-X POST \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-d '{"code":"e0035223-44dc-4146-9322-4001a56e0417"}' | python -mjson.tool
```
```
{
    "access_token": "tkn.v1_ZWNiYjFhNWUtYjg4OS00ODNlLTk1OTYtMjQ4YjlhZTFlM2I2LTU4ODQzNC40NzE0NjYuRVU=",
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
    "user": {
        "id": 471466,
        "firstName": "Alejandro",
        "lastName": "Ramirez",
        "email": "alejandro.ramirez@teamwork.com",
        "avatar": "https://s3-eu-west-1.amazonaws.com/tw-eu-files/588434/userAvatar/twia_fd233d46c8c9c58722aa81a3b0885849.png",
        "company": {
            "id": 150787,
            "name": "Beforeigners",
            "logo": "https://s3-eu-west-1.amazonaws.com/tw-eu-files/"
        }
    }
}
```
