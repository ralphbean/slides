#!/bin/bash
# Make index.html files

for dirname in . $(find * -type d); do
	rm "$dirname/index.html";
	for child in $(ls $dirname); do
		echo '<br/><a href="'"$child"'">'"$child"'</a>' >> "$dirname/index.html";
	done;
done
