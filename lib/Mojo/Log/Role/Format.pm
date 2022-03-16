package Mojo::Log::Role::Format;
use Mojo::Base -role;

has serialize => sub { \&_serialize };

sub logf {
  my ($self, $level, $format, @args) = @_;
  $self->$level(@args ? sprintf $format, $self->serialize->(@args) : $format)
    if $self->is_level($level);
  return $self;
}

sub _serialize {
  my @args = map { ref $_ eq 'CODE' ? $_->() : $_ } @_;

  local $Data::Dumper::Indent    = 0;
  local $Data::Dumper::Maxdepth  = $Data::Dumper::Maxdepth || 2;
  local $Data::Dumper::Pair      = ':';
  local $Data::Dumper::Quotekeys = 1;
  local $Data::Dumper::Sortkeys  = 1;
  local $Data::Dumper::Terse     = 1;
  local $Data::Dumper::Useqq     = 1;

  for (@args) {
    $_
      = !defined($_)                ? 'undef'
      : overload::Method($_, q("")) ? "$_"
      : ref($_)                     ? Data::Dumper::Dumper($_)
      :                               $_;
  }

  return @args;
}

1;
