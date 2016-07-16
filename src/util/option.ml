
let may ~default = function
  | None -> default
  | Some s -> s

let none_apply ~f = function
  | None -> f ()
  | Some s -> s

let pp_option ~ppo fmt o = match o with
  | None -> ()
  | Some elt -> Format.fprintf fmt "%a" ppo elt
