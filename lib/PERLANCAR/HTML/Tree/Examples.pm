package PERLANCAR::HTML::Tree::Examples;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use HTML::Tree::Create::Callback::ChildrenPerLevel
    qw(create_html_tree_using_callback);
use Exporter::Rinci qw(import);

our %SPEC;

$SPEC{gen_sample_html} = {
    v => 1.1,
    summary => 'Generate sample HTML document',
    description => <<'_',

This routine can generate some sample HTML document with specified size (total
number of elements and nested level). It is used for testing and benchmarking
HTML::Parser or CSS selector like `Mojo::DOM`.

_
    args => {
        size => {
            summary => 'Which document to generate',
            schema => ['str*', in=>['tiny1', 'small1', 'medium1']],
            description => <<'_',

There are several predefined sizes to choose from. The sizes are roughly
equivalent to sample trees in `PERLANCAR::Tree::Examples`.

`tiny1` is a very tiny document, with only depth of 2 and a total of 3 elements,
including root node.

`small1` is a document of depth 4 and a total of 16 elements, including root
element.

`medium1` is a document of depth 7 and ~20k elements.

_
            req => 1,
            pos => 0,
        },
        backend => {
            schema => ['str*', in=>['array', 'hash']],
            default => 'hash',
        },
    },
    result => {
        schema => 'str*',
    },
    result_naked => 1,
};
sub gen_sample_html {
    my %args = @_;

    my $size = $args{size} or die "Please specify size";

    my $nums_per_level;
    my $elems_per_level;
    if ($size eq 'tiny1') {
        $nums_per_level = [2];
        $elems_per_level = ['body', 'p'];
    } elsif ($size eq 'small1') {
        $nums_per_level = [3, 2, 8, 2];
        $elems_per_level = ['body', 'class', 'table', 'tr', 'td'];
    } elsif ($size eq 'medium1') {
        $nums_per_level = [100, 3000, 5000, 8000, 3000, 1000, 300];
        $elems_per_level = ['body', 'class', 'class', 'class', 'class',
                            'table', 'tr', 'td'];
    } else {
        die "Unknown size '$size'";
    }

    my $id = 0;
    create_html_tree_using_callback(
        sub {
            my ($level, $seniority) = @_;
            $id++;
            my $elem = $elems_per_level->[$level];
            return ($elem, {id=>$id, 'data-level' => $level}, '', '');
        },
        $nums_per_level,
    );
}

1;
# ABSTRACT:

=head1 SYNOPSIS

 use PERLANCAR::HTML::Tree::Examples qw(gen_sample_html);

 my $html = gen_sample_html(size => 'medium1');


=head1 DESCRIPTION
