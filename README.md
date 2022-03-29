# SSH Server GitHub Action

[![test](https://github.com/Tofandel/ssh-server-action/actions/workflows/test.yml/badge.svg)](https://github.com/Tofandel/ssh-server-action/actions/workflows/test.yml)

This [GitHub Action](https://github.com/features/actions) sets up a SSH server for testing purposes.

It is based on the Docker container and is limited by Github Actions, which contains only Linux now. Therefore it does not work in Mac OS and Windows environment.

## Usage

```yaml
steps:
- uses: tofandel/ssh-server-action@v1.1
  with:
    hostname: dev.com # Optional, the display hostname of the server
    port: 2222 # Optional, default value is 22. The exposed ssh port
    user_name: my-user # Optional, default value is ssh-user
    user_password: $SECRET_PASSWORD # Optional
    sudo_access: true # Optional, allow user to use sudo without password, default: false
    public_key: $PUBLIC_KEY # Optional, Public key authorized to access the server
    public_key_url: https://github.com/${{ github.actor }}.keys # Optional, url to retrieve the public key
```

## License

This project is released under the [MIT License](LICENSE).
