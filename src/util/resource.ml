
type 'a get = unit -> 'a
type 'a release = 'a -> unit
type 'a resource = 'a get * 'a release

let with_resource (o, c) f =
  let resource = o () in
  try
    let result = f resource in
    c resource;
    result
  with exn ->
    c resource;
    raise exn

module Infix = struct
  let ( >>+ ) = with_resource
end
