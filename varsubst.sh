SEDOPTS=""
for x in $1; do
	SEDOPTS="$SEDOPTS -e 's@$x@$(eval "echo \"\$$x\"")@g'"
done
eval sed $SEDOPTS
