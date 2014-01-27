#!/usr/bin/perl -w
use strict;
require File::Slurp;
require String::Tokenizer;

my %reserved_words =
    {
        "begin" => 1,
        "end" => 2,
        "require" => 3,
        "def" => 4,
        "class" => 5,
        "if" => 6,
        "while" => 7,
        "else" => 8,
        "elsif" => 9,
        "for" => 10,
        "return" => 11,
        "and" => 12,
        "or" => 13    
    };

sub main {
    open my $fh, 'input.in' or die "Can't open file $!";
    my $input_file = do { local $/; <$fh> };
    
    my $tokenizer = String::Tokenizer->new();
    
    $tokenizer->tokenize($input_file);
    my $i = $tokenizer->iterator();
    my $token = $i->nextToken();
    while ($token != "?") {
        
    }
    
}



&main();