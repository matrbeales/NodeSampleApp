# node-server-cookbook
A chef cookbook used to create a generic rails server

## Usage

metadata.rb
```
depends 'node-server', path: 'git@github.com:spartaglobal/node-server-cookbook.git'
```

default.rb
```
include_recipe 'node-server::default'
```

