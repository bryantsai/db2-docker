# DB2 on Docker

This work is built on top of https://github.com/jeffbonhag/db2-docker. Kudos to jeffbonhag.

**Note the Docker version used to create this was 1.2.0. The DB2 used was Express-C version 10.5 FP4.**

## Building DB2 docker images

The first thing is to [Download DB2 Express-C](http://www.ibm.com/software/data/db2/express-c/download.html). Put the downloaded file `v10.5_linuxx64_expc.tar.gz` in the `expc` sub-directory. If somehow the filename is changed in the future, just replace the name in `expc/Dockerfile` with the new one.

Run the build script

    ./build.sh

It builds an image `db2:expc` with DB2 Express-C compact installation (no instance created) and another "data-only" container named "`db2_data_1`". More on this "data-only" container in the next section.

You only need to run "`build.sh`" once per Docker install. There's a separate shell script "`create-inst.sh`" for creating additional DB2 containers: 

    ./create-inst.sh 2

This creates a new "data-only" container "`db2_data_2`".

# Running the DB2 docker image

Use the included shell script to run:

    ./run-inst.sh [instance #]

The optional parameter indicates which DB2 instance to run. Of course, you have to create the corresponding instance first.

This run script issues `db2start` for you and then puts you in the bash shell. Initially there is no database created yet. You can create one easily after entering the container's shell as "`db2inst1`":

    > db2 "create db sample"

After the database is created, you can safely logout of the container as the database's data files are stored in another "data-only" container. Run the launch script as many times as you want. You will always be able to connect to the same persisted database content as long as you don't manually remove the "data-only" container (see later section for more details).

*When launching from the run script, you might see the following error message. It does not seem to cause any problem for DB2.*

    $ ./run-inst.sh
    SQL1063N  DB2START processing was successful.
    bash: cannot set terminal process group (7): Inappropriate ioctl for device
    bash: no job control in this shell
    $ 

There's another script for starting DB2 contatiner and keep it running in the background:

    ./run-inst-server.sh [instance #]

Of course, create the database (using `run-inst.sh` to enter the container shell) first before you run this.

Also note that since DB2 is not meant to be running multiple server instances agains the same set of database data files, you should only keep one DB2 instance running at all time. If you do use the launch script to run DB2 instances, it takes care of that since instance containers are named like "`db2_inst_1`".

To access the DB2 instance in the container from outside world, you need to lookup Docker's mapped public port:

    docker port <container ID> 50000

50000 is the container private port (the one we used inside the container).

# Cleaning images

There's a script included to help clean up everything related to a specific instance's images:

    ./clean-inst.sh [instance #]

# Some Background ...

There are 2 problems (with the Docker version used at the time) running DB2 on Docker.

## Privileged Run Mode

DB2 has a problem where it needs more shared memory than Docker originally provides. So to run DB2 on Docker, you need to run the container in privileged mode, that is:

    docker run --privileged=true ...

This will increase the max shared memory size. Of course, the included run script already does that for you.

## Docker Storage

Because DB2 uses O_DIRECT system call, the default Docker AUFS does not work for DB2. There are 2 options to work-around it:

1. Use volume.
2. Use devicemapper storage mode for Docker. See [Switching Docker from aufs to devicemapper](http://muehe.org/posts/switching-docker-from-aufs-to-devicemapper/).

The first option is used in this code, as the second option requires change of docker daemon options.

Note that we use [Persistent volumes with Docker - Data-only container pattern](http://www.tech-d.net/2013/12/16/persistent-volumes-with-docker-container-as-volume-pattern/) Docker "data-only" container pattern. That's why you would see a container named like "`db2_data_1`" using command `docker ps -a`. You don't really need to worry about the "data-only" container as long as you don't delete it (it is not actually running).

See also [Docker user guide](https://docs.docker.com/userguide/dockervolumes/).
