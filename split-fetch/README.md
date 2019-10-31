# Split Fetch

Thank you to
[lukechampine](https://twitter.com/lukechampine/status/1189921698201690124)
for this example.

## Problem description:

We have split up a file and stored it across 10 different "hosts." The file
has been erasure-encoded, such that we can reconstitute it using the pieces
of *any* 6 hosts. Our goal is to download 6 pieces in parallel and
reconstitute the file.

A simple strategy would be to request the piece of *every* host in parallel,
and use whichever 6 pieces arrive first. But this wastes resources: imagine
if it cost $1 to download a piece. Alternatively, we could start by
requesting pieces from 6 hosts, and only try new hosts if necessary. But this
is slow: imagine if 1 host took 10 seconds to respond.

Here, we compromise by requesting pieces from 7 hosts. If a host fails, we
request a piece from one of the remaining hosts. At any point, if 6 hosts
succeed or >4 hosts fail, we are done, and cancel any active requests. This
strategy wastes some resources, but in return, it avoids getting bottlenecked
by the slowest host.

## Status

Work-in-progress. The Zig standard library needs more networking support before
this comparison can happen.
