#!/bin/bash
# Make index.html files

for dirname in . $(find * -type d); do
	rm "$dirname/index.html";
	for child in $(find "$dirname" -maxdepth 1 -mindepth 1); do
		echo '<br/><a href="/'"$child"'">/'"$child"'</a>' >> "$dirname/index.html";
	done;
done
