#!/usr/bin/perl -w
use warnings;
use strict;

my $current_line = <>;

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
    my $token = get_next_char();
    while ($token ne '?') {
        if($token =~ /[A-Za-z_]/){
            process_identifier($token);
        }
        elsif($token =~ /\d/){
            process_digit($token);
        }
        elsif($token eq "\""){
            process_string($token);
        }
        elsif($token eq "#"){
            process_comment($token);
        }
        elsif($token =~ /\S/){
            process_operator($token);
        }
        elsif($token eq "\n"){
            chomp $token;
            $token = get_next_char();
        }
        $token = get_next_char();
    }
    print "End Token: " . $token; 
}

sub process_identifier {
    my $token = "";
    my $ch = $_[0];
    $token .= $ch;
    my $not_done = 1;
    while ($not_done) {
        $ch = get_next_char();
        if ($ch =~ /\W/) {
            push_back($ch);
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
    $token .= $ch;
    my $not_done = 1;
    while ($not_done) {
        $ch = get_next_char();
        if ($ch =~ /\D/) {
            push_back($ch);
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
    $token .= $ch;
    while ($not_done) {
        $ch = get_next_char();
        if ($ch eq "\\") {
            $token .= $ch;
            $ch = get_next_char();
            if ($ch eq "\"") {
                $token .= $ch;
            }
            else {
                push_back($ch);
            }
        }
        else {
            $token .= $ch;
            if ($ch eq "\"") {
                print "String: $token\n";
                $not_done = 0;
            }
            elsif($ch eq "\n") {
                print "Bad String: $token\n";
                push_back($ch);
                $not_done = 0;
            }
        }
    }
}

sub process_comment {
    my $not_done = 1;
    my $token = "";
    my $ch = $_[0];
    $token .= $ch;
    while ($not_done) {
        $ch = get_next_char();
        if ($ch eq "\n") {
            push_back($ch);
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
    $token .= $ch;
    if ($ch =~ /[\+\-\*\/\<\>\!\~\^\%\&\|\:\'\;\=\`\[\]\,\@\(\)\$\{\}\\]/) {
        my $ch1 = get_next_char();
        if ($ch1 eq "=") {
            $token .= $ch1;
            print "Operator: $token\n";
        }
        else {
            print "Operator: $token\n";
            push_back($ch1);
        }
    }
    elsif($ch eq ".") {
        $ch = get_next_char();
        if ($ch eq ".") {
            $token .= $ch;
            my $ch1 = get_next_char();
            if ($ch1 eq ".") {
                $token .= $ch1;
                print "Operator: $token\n";
            }
            else {
                print "Operator: $token\n";
                push_back($ch1);
            }
        }
        else {
            print "Operator: $token\n";
            push_back($ch);
        }
    }
}

sub get_next_char {
   my $ch = "";
   if ($current_line eq "") {
        $current_line = <>;
   }
   else{
        #$current_line =~ s/^(.).*/$1/;
        $ch = substr $current_line, 0, 1, "";
        return $ch;
   }
}

sub push_back {
    my $ch = $_[0];
    $current_line = $ch . $current_line;
}

&main();