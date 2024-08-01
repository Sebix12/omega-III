if youre not a dev, just discard this, this is for the open source plugin and code development, mainly for explaining my unreadable code, but also contains variable meanings and the "tree" of the static file server.

Domains: [ backup.xdev.lol/omega-iii ]:










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
#

File access tree:
    #omega.cmd:
        -kernel.bat:
            dbm.bat
            fs.bat
            plugins.bat
            dmg.bat:
                crypt
                cipher
                comp
                get
        
        