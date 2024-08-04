if youre not a dev, just discard this, this is for the open source plugin and code development, mainly for explaining my unreadable code, but also contains variable meanings and the "tree" of the static file server.

Domains: [ backup.xdev.lol/omega-iii ]:
#

omega start vars:
    "-clean-install"
    "-update-kernel"
    "-update-kernel-hash"
    "-use-custom-kernel"
# 


Vars: 
    -%domain% = backup.xdev.lol
    -%downdomain% = !domain!/omega-iii/omega-iii : (backup.xdev.lol/omega-iii/omega-iii)
    -%defloc% = start directory
    -
    -
    -
    -
    -
#

Current tool library:
    -certutil.exe
    -cipher.exe
    -curl.exe
    -tar.exe
    -robocopy.exe
#

File access tree:
    #omega.cmd:
        -kernel.bat:
            -checkup
            
                -list
                -run
                -remove
                -get
            fs:
                mkdir
                rmdir
                rm
                cp
            crypt:
                certutil:
                    -encode
                    -decode
                    -hashfile
                cipher:
                    -encrypt
                    -decrypt
            datamg:
                comp:
                    -create
                    -extract
#

command usage tree:
    exit
    help


commands: omega.cmd (clean-install/update-kernel)


developer tools:
autohash: http://backup.xdev.lol/omega-iii/omega-iii/autohash.bat, creates a kernel hash every 2 seconds so you dont have to
