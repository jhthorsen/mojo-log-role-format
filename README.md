# NAME

Mojo::Log::Role::Format - Add sprintf logging to Mojo::Log

# SYNOPSIS

    use Mojo::Log;
    my $log = Mojo::Log->new->with_roles('+Format')->level('debug');

    # [info] cool beans
    $log->logf(info => 'cool %s', 'beans');

    # [warn] serializing {"data":"structures"}
    $log->logf(warn => 'serializing %s', {data => 'structures'});

# DESCRIPTION

[Mojo::Log::Role::Format](https://metacpan.org/pod/Mojo%3A%3ALog%3A%3ARole%3A%3AFormat) is a [Mojo::Log](https://metacpan.org/pod/Mojo%3A%3ALog) role which allow you to log with
a format like `sprintf()`, avoid "Use of uninitialized" warnings and will
also serialize data-structures and objects.

# ATTRIBUTES

## logf\_serialize

    $cb = $log->logf_serialize;
    $log = $log->logf_serialize(sub (@args) { ... });

This attribute must hold a callback that will be used to serialize the arguments
passed to ["logf"](#logf).

The default callback uses [Data::Dumper](https://metacpan.org/pod/Data%3A%3ADumper) with some modifications, but these
settings are currently EXPERIMENTAL and subject to change:

    $Data::Dumper::Indent    = 0;
    $Data::Dumper::Maxdepth  = $Data::Dumper::Maxdepth || 2;
    $Data::Dumper::Pair      = ':';
    $Data::Dumper::Quotekeys = 1;
    $Data::Dumper::Sortkeys  = 1;
    $Data::Dumper::Terse     = 1;
    $Data::Dumper::Useqq     = 1;

# METHODS

## logf

    $log = $log->logf($level => $format, @args);
    $log = $log->logf($level => $message);

See ["SYNOPSIS"](#synopsis).

# AUTHOR

Jan Henning Thorsen

# COPYRIGHT AND LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.

# SEE ALSO

[Mojo::Log](https://metacpan.org/pod/Mojo%3A%3ALog)
