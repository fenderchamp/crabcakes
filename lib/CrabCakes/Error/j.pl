
my $a = [
{ 
a => 2,
b => 1,
},
{ 
a => 2,
b => 1,
}
];

print join ',' ,  map $_->{a} , @$a ;



