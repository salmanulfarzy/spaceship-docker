Docker images to easily setup and run [`spaceship-prompt`][1] 

#### Setup

Build images with 

```
docker build --tag "zsh-{version}" --file=./base-{version}/Dockerfile .
```

Run containers with

```
docker run --rm -it zsh-{version}
```

#### Available Images

Images for more `Zsh` versions, frameworks and plugin managers will be added soon.

|`Zsh` version |        Base Image        | 
|:-------------|:-------------------------|
| `Zsh v5.5.1` | [zsh-users/zsh-5.5.1][2] |
| `Zsh v5.4.2` | [zsh-users/zsh-5.4.2][3] |
| `Zsh v5.3.1` | [zsh-users/zsh-5.3.1][4] |
| `Zsh v5.2`   | [zsh-users/zsh-5.2][5]   |

#### LICENCE

MIT © [Salmanul Farzy][6]

[1]: https://github.com/denysdovhan/spaceship-prompt
[2]: https://hub.docker.com/r/zshusers/zsh-5.5.1
[3]: https://hub.docker.com/r/zshusers/zsh-5.4.2
[4]: https://hub.docker.com/r/zshusers/zsh-5.3.1
[5]: https://hub.docker.com/r/zshusers/zsh-5.2
[6]: https://github.com/salmanulfarzy
