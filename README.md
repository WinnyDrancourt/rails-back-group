# Back Api with Rails

## Request User

- Creation of a user : Url/users POST

  - Request :

```json
{
  "user": {
    "email": "test@test.fr",
    "password": "test"
  }
}
```

- Connection of a user : Url/users/sign_in POST

  - Request :

```json
{
  "user": {
    "email": "test@test.fr",
    "password": "test"
  }
}
```

- Update of a user : Url/users PUT

  - Request :

```json
{
  "user": {
    "email": "test@test.fr",
    "password": "test"
  }
}
```

- Log out of a user : Url/users/sign_out DELETE
  -Request :

```json
{
  "headers": {
    "content-type": "application/json",
    "Authorization": "Bearer token"
  }
}
```

- All product of a user : Url/users/:userId/products GET

## Request Product

- Creation of a product : Url/products POST

  - Request :

```json
  {
    "headers": {
      "content-type": "application/json",
      "Authorization": "Bearer token"
    }
    "product": {
      "title": "test",
      "price": 10,
      "quantity": 10
    }
  }
```

- Update of a product : Url/products PUT

  - Request :

```json
  {
    "headers": {
      "content-type": "application/json",
      "Authorization": "Bearer token"
      }
    "product": {
      "title": "test",
      "price": 10,
      "description": "test"
    }
  }
```

- Delete of a product : Url/products DELETE

  - Request :

```json
{
  "headers": {
    "content-type": "application/json",
    "Authorization": "Bearer token"
  }
}
```

-Gets all products : Url/products GET

-Gets a product : Url/products/:id GET
