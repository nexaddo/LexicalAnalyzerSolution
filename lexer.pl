#!/usr/bin/perl -w
use warnings;
use strict;

use String::Tokenizer;

my %reserved_words =
    (
        'begin' => 1,
        'end' => 2,
        'require' => 3,
        'def' => 4,
        'class' => 5,
        'if' => 6,
        'while' => 7,
        'else' => 8,
        'elsif' => 9,
        'for' => 10,
        'return' => 11,
        'and' => 12,
        'or' => 13    
    );

sub main {
    open(my $fh, '<', 'input.in') or die "Can't open file $!";
    my $input_file = do { local $/; <$fh> };
    
    my $tokenizer = String::Tokenizer->new();
    $tokenizer->handleWhitespace(String::Tokenizer->RETAIN_WHITESPACE);
    
    $tokenizer->tokenize($input_file);
    my $i = $tokenizer->iterator();
    my $token = $i->nextToken();
    while ($token ne '?') {
        if($token =~ /[A-Za-z_]/){
            process_identifier($token, $i);
        }
        elsif($token =~ /\d/){
            process_digit($token, $i);
        }
        elsif($token =~ /"/){
            process_string($token, $i);
        }
        elsif($token =~ /#/){
            process_comment($token, $i);
        }
        elsif($token =~ m/\S/){
            process_operator($token, $i);
        }
        elsif($token =~ /"\n"/){
            $i->skipTokens(1);
            $token = $i->nextToken();
        }
        $token = $i->nextToken();
    }
    print "End Token: " . $token; 
}

sub process_identifier {
    my $token = "";
    my $ch = $_[0];
    my $i = $_[1];
    $token .= $ch;
    my $not_done = 1;
    while ($not_done) {
        $ch = $i->nextToken();
        if ($ch =~ /\W/) {
            $i->prevToken();
            $not_done = 0;
        }
        else{
            $token .= $ch;
        }
    }
    if (exists($reserved_words{$token})) {
        print "Reserved Word: " . $token . " - " . "$reserved_words{$token}\n";
    }
    else{
        print "Identifier: " . "$token\n";
    }
}

sub process_digit {
    my $token = "";
    my $ch = $_[0];
    my $i = $_[1];
    
    $token .= $ch;
    my $not_done = 1;
    while ($not_done) {
        $ch = $i->nextToken();
        if ($ch =~ /\D/) {
            $i->prevToken();
            $not_done = 0;
        }
        else{
            $token .= $ch
        }
    }
    print "Number: $token\n";
}

sub process_string {
    my $not_done = 1;
    my $token = "";
    my $ch = $_[0];
    my $i = $_[1];
    $token .= $ch;
    while ($not_done) {
        $ch = $i->nextToken();
        if ($ch =~ /\\/) {
            $token .= $ch;
            $ch = $i->nextToken();
            if ($ch =~ /"/) {
                $token .= $ch;
            }
            else {
                $i->prevToken();
            }
        }
        else {
            $token .= $ch;
            if ($ch =~ /"/) {
                print "String: $token\n";
                $not_done = 0;
            }
            elsif($ch eq "\n") {
                print "Bad String: $token\n";
                $i->prevToken();
                $not_done = 0;
            }
        }
    }
}

sub process_comment {
    my $not_done = 1;
    my $token = "";
    my $ch = $_[0];
    my $i = $_[1];
    $token .= $ch;
    while ($not_done) {
        $ch = $i->nextToken();
        if ($ch eq "\n") {
            $i->prevToken();
            $not_done = 0;
        }
        else {
            $token .= $ch;
        }
    }
    print "Comment: $token";
}

sub process_operator {
    my $not_done = 1;
    my $token = "";
    my $ch = $_[0];
    my $i = $_[1];
    $token .= $ch;
    if ($ch =~ /[\+\-\*\/\<\>\!\~\^\%\&\|\:\'\;\=\`\[\]\,\@\(\)\$\{\}\\]/) {
        my $ch1 = $i->nextToken();
        if ($ch1 eq "=") {
            $token .= $ch1;
            print "Operator: $token\n";
        }
        else {
            print "Operator: $token\n";
            $i->prevToken();
        }
    }
    elsif($ch eq ".") {
        $ch = $i->nextToken();
        if ($ch eq ".") {
            $token .= $ch;
            my $ch1 = $i->nextToken();
            if ($ch eq ".") {
                $token .= $ch1;
                print "Operator: $token\n";
            }
            else {
                print "Operator: $token\n";
                $i->prevToken();
            }
        }
        else {
            print "Operator: $token\n";
            $i->prevToken();
        }
    }
}

sub get_next_char {
    
}


&main();