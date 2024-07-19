# ssh-mirror

This project tunnels ssh posts from a remote server to localhost

## Building the Binary

To build the binary from the `ssh-mirror.sh` script, follow these steps:

### Install Dependencies

Make sure you have `shc` and a C compiler (`gcc`) installed.

- **On Debian/Ubuntu:**
```
sudo apt-get update
sudo apt-get install shc build-essential
```
- **On Red Hat/CentOS:**
```
sudo yum install shc gcc
```

### Compile the Script

Navigate to the directory where the `ssh-mirror.sh` script is located and run `shc`:
```
shc -f ssh-mirror.sh -o ssh-mirror.sh.x
```

This will generate the file `ssh-mirror.sh.x.c`. Compile this C file to create the binary:

```
gcc -o ./usr/local/bin/ssh-mirror ssh-mirror.sh.x.c
```

The generated binary will be named `ssh-mirror`.

## Generating the `.deb` Package

To create a `.deb` package from the binary and project files, follow these steps:

1. **Package Structure**

Ensure the directory structure is set up correctly. The project directory should be organized as follows:

   ssh-mirror/ \
   ├── DEBIAN/ \
   │   └── control \
   ├── usr/ \
   │   └── local/ \
   │       └── bin/ \
   │           └── ssh-mirror \
   └── ssh-mirror.sh

### Build the `.deb` Package

   Navigate to the parent directory containing the `ssh-mirror` directory and run the `dpkg-deb` command:
```
dpkg-deb --build . ssh-mirror.deb
```
This will create the `ssh-mirror.deb` file in the current directory.

## Installing the `.deb` Package

To install the `.deb` package, run:
```
sudo dpkg -i ssh-mirror.deb
```
## Config

You must configure your ssh accesses in `~/ssh-mirror-config.json` following the example:
```
{
    "dev" : {
        "credentials": {
            "user": "root",
            "port": 22,
            "host": "00.000.0.00",
            "key_path": "/home/pl-90/.ssh/id_rsa"
        },
        "ports": [
            "5439:5432", 
            "9009:9000",
            "3009:3000"
        ]
    }
}
```
The format of the ports: ```local:remote```

## Executing
```
ssh-mirror <your-config>
```