name: Ruby

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

permissions:
  contents: read

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        ruby-version: ['2.6']

    steps:
    - uses: actions/checkout@v3
    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: ${{ matrix.ruby-version }}
    - name: Add the gem path to the environment variables
      run: |
        echo "::stop-commands::`echo -n ${{ github.token }} | sha256sum | head -c 64`"
        echo "::add-path::$(ruby -e 'puts Gem.user_dir')/bin"
        echo "::`echo -n ${{ github.token }} | sha256sum | head -c 64`::"
    - name: Install dependencies
      run: |
        gem install bundler
        bundle install
    - name: Run tests
      run: cucumber -p default -p chrome -p headless --retry 2 
