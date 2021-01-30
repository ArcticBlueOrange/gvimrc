import os, sys
import shutil

"""
Gvimrc manager
Opens a text file for settings
if file was missing, create it
    if file is new
        ask where is the git folder and the vimrc folder
        ask if the filename is going to be .vimrc or .gvimrc
    else
        goes to main function
main function
    arguments
        noargs:     copies the file from git folder to home folder
        -b, --back  copies the file form home to git

"""

# Variables
settings_filename = "movevimrc_settings.txt"
settings = {
        'rcpath'  : '',
        'gitpath' : '.',
        'filename': '.gvimrc'}
filepath = f"{settings['gitpath']}\\{settings_filename}"

try:
    with open(filepath, 'r') as sfn:
        rows = sfn.read().splitlines()
        settings['filename'] = rows[0]
        settings['rcpath']   = rows[1]
        settings['gitpath']  = rows[2]
except Exception as e:
    print(e)
    print("New setup - please answer the following questions")
    cont = True
    while cont:
        filename = input('The (g)vimrc or (v) vimrc?\t')
        rcpath = input("Where to save the .rc file?\t")
        gitpath = input("Where is the source git?\t")
        if filename not in ['g','v','G','V']:
            print('Restarting..')
        else:
            filename = '.gvimrc' if filename in ['g','G'] else '.vimrc'
            cont = False
    settings['filename'] = filename
    settings['rcpath']   = rcpath
    settings['gitpath']  = gitpath
    filepath = f"{settings['gitpath']}\\{settings_filename}"
    with open(filepath, 'w') as sfn:
        print("Writing to file")
        sfn.writelines(f'{filename}\n{rcpath}\n{gitpath}')
    print('Done!')


if __name__ == "__main__":
    cont = True
    while cont:
        print("Select the operation you want to do")
        print(f"1 for moving {settings['filename']} from {settings['gitpath']} to {settings['rcpath']}")
        print(f"2 for moving {settings['filename']} from {settings['rcpath']} to {settings['gitpath']}")
        ans = input()
        if ans == '1':
            print(f"Copying {settings['filename']} from {settings['gitpath']}...")
            shutil.copyfile( f"{settings['gitpath']}{settings['filename']}", f"{settings['rcpath']}{settings['filename']}" )
            print(f"\t...Pasted into {settings['rcpath']}")
            cont = False
        elif ans == '2':
            print(f"Copying {settings['filename']} from {settings['rcpath']}...")
            shutil.copyfile( f"{settings['rcpath']}{settings['filename']}", f"{settings['gitpath']}{settings['filename']}" )
            print(f"\t...Pasted into {settings['gitpath']}")
            cont = False

#print(settings)
print('End')

