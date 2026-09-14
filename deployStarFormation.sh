#!/bin/bash

starformation="/home/ken/Documents/src/StarFormation"
numerics="/home/ken/Documents/src/richardskg.github.io"
jupyterlite="/home/ken/Documents/src/jupyterlite"

function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Aborted" ; return  1 ;;
        esac
    done
}

read -p "Enter the commit message " git_message

#------------------ convert the notebook to html ------------------ 
cd $starformation
pwd

jupyter nbconvert --to html --template pj --HTMLExporter.sanitize_html=False starformation.ipynb

#------------------ add google tracking to the html: ------------------ 
sed -i 's#<head>#<head>\
<!-- Google tag (gtag.js) -->\
<script async src="https://www\.googletagmanager\.com/gtag/js?id=G-TTW395TP1L"></script>\
#' starformation.html

#------------------ add the menu to the html: ------------------ 
sed -i 's#<body>#<body>\
		<header>\
			<h1>Physics!</h1>\
			<nav>\
				<ul class="lavaLampWithImage" id="lava_menu">\
					<li><a href="index\.html">home</a></li>\
					<li><a href="simulations\.html">physics home</a></li>\
					<li><a href="\./BField\.html">particle in constant field</a></li>\
					<li><a href="\./ECrossB\.html">particle in crossed fields</a></li>\
					<li class="current"><a href="\./Lines\.html">1D MHD</a></li>\
					<li><a href="\./MHD-equations\.html">Equations</a></li>\
          <li><a href="\./starformation\.html">Star Formation</a></li>\
				</ul>\
			</nav>\
			<p></p>\
		</header>\
#' starformation.html

#------------------  copy the notebook to jupyterlite and the html to NephiNumerics ------------------ 
cp starformation.ipynb $jupyterlite/content
cp starformation.html $numerics

#------------------ Now update git ------------------ 
function git_push {
    echo
    echo "---------------------------------"
    echo -n 'Running git push from: ' 
    pwd
    echo git message: """$git_message"""
    # show the status so the user knows if they want to commit/push
    git status
    echo " Do you want to continue?"
    
    if yes_or_no; then
        echo "pushing..."
        git add -A
        git commit -m """$git_message"""
        git push
    fi
}

cd $starformation
git_push 

cd $numerics
git_push

cd $jupyterlite
git_push










