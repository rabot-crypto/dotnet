# How to test

1. `git submodule update --init --recursive`
2. `dagger --log-format plain --log-level debug do pack`

# How to clean

1. `git submodule deinit .`
2. `rm -r .artifacts/`

# How to update

1. `git submodule update --init --remote --merge`
2. `git add .`
3. `git commit -m "updated submodule tip(s)"`
4. `git push -u origin HEAD`
