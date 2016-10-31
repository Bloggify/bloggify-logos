#!/bin/bash
cd assets
for resource in */ ; do
    resource=${resource%/}
    echo ">> $resource"

    if [[ "$resource" != "mascot" ]] ; then
        cd $resource
        mkdir -p png
        for res_type in svg/ ; do
            echo " > $res_type"
            cd $res_type
            for file_name in *.svg ; do
                svgName=${file_name##*/}
                echo "  > $svgName"

                echo "    * Transparent"
                transparent=../png/$svgName-transparent.png
                white=../png/$svgName-white.png
                black=../png/$svgName-black.png

                inkscape \
                    --export-png=$transparent --export-dpi=200 \
                    --export-background-opacity=0 --without-gui $file_name

                echo "    * Black"
                convert $transparent -background white -alpha remove $white

                echo "    * White"
                convert $white -negate $black
            done
            cd ..
        done
        cd ..
    fi

    zip -r ../zips/$resource.zip $resource
done
