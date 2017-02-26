#!/bin/bash
cp -R $1.l AFLEXNAT/
./AFLEXNAT/aflex -E $1.l

rm -rf Result
mkdir Result
mv $1* Result
cd Result

gnatchop -w $1_io.a
gnatchop -w $1_dfa.a
gnatchop -w $1.a
rm $1*.a
cd ..
