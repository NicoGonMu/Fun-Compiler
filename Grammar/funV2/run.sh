#!/bin/bash
cp -R $1.y ./../AYACCNAT/
./../AYACCNAT/ayacc $1.y off off on on

rm -rf Result
mkdir Result
mv $1* Result
cd Result

gnatchop -w $1.a
rm $1*.a
cd ..
