open Odot;;
open List;;

let node_name n = match n with
| Stmt_node ((Double_quoted_id s, _), _) -> s
| _ -> failwith "Not a string!";;

let is_node st = match st with
| Stmt_node _ -> true
| _ -> false;;

let rec add_instr_l instrs label a = match instrs with
| (li, a', lp) :: t when a = a' -> (label :: li, a, lp) :: t
| h :: t -> h :: add_instr_l t label a
| [] -> [([label], a, [])];;

let rec add_instr_r instrs a label = match instrs with
| (li, a', lp) :: t when a = a' -> (li, a, label :: lp) :: t
| h :: t -> h :: add_instr_r t a label
| [] -> [([], a, [label])];;

let plain_string_of_id = function
| Simple_id s -> s 
| Html_id s -> s
| Double_quoted_id s -> s;;

let rec node_ids = function
| (Edge_node_id (id, _)) :: t -> plain_string_of_id id :: node_ids t
|  _ :: t -> node_ids t
| [] -> [];;      

let rec instructions_aux ingr edges instrs = match edges with
| (Stmt_edge (Edge_node_id n, l, attrs)) :: t -> 
    let x = plain_string_of_id (fst n) in
    let y = List.hd (node_ids l) in (* cheat: assume only one output *)
    (match attr_value (Simple_id "label") attrs with
    | Some id -> 
        let label    = plain_string_of_id id in
        let instrs'  = add_instr_r instrs x label in
        let instrs'' = add_instr_l instrs' label y in
            instructions_aux ingr t instrs''
    | None -> (* either an ingredient or the result *)
        if List.mem x ingr then 
            instructions_aux ingr t (add_instr_l instrs x y)
        (* result. we can write an ending comment *) 
        else if List.mem y ingr then
            instrs
        else failwith ("You might have forgotten a label: " ^ x ^ " -> " ^ y)
     )
| _ :: t -> instructions_aux ingr t instrs (* not an edge *)
| [] -> instrs;;

(* ingredients + result *)
let ingredients graph = 
    List.map node_name (List.filter is_node graph.stmt_list);;

let instructions graph = 
    instructions_aux (ingredients graph) graph.stmt_list [];;

let rec string_of_ingredients word = function
| i :: i' :: i'' :: t -> word ^ i ^ ", " ^ (string_of_ingredients word (i' :: i'' :: t))
| i :: i' :: [] -> word ^ i ^ " and " ^ word ^ i'
| i :: [] -> word ^ i
| [] -> "" 

(* test *)

let string_of_instruction (li, a , lp) =
    if lp = [] then 
        "* Finally, "^ a ^ " " ^ (string_of_ingredients "the " li) ^ "\n"
    else
        "* " ^ a ^ " " ^ (string_of_ingredients "the " li) ^ " to obtain " ^
            (string_of_ingredients "" lp) ^ "\n";;

let rec ordered_string_of_instructions ingr instr c = 
    if c = 0 then failwith "missing steps !"
    else
        (match instr with
        | [] -> ""
        | (li, a, lp) :: t -> 
            if for_all (fun x -> mem x ingr) li then
                string_of_instruction (li, a, lp) ^ ordered_string_of_instructions (lp @ ingr) t (c - 1)
            else (* may not terminate, you fool ! *)
                ordered_string_of_instructions ingr (t @ [(li, a, lp)]) (c - 1));;

let string_of_instructions graph =
    let instr = instructions graph in
    let n = List.length instr in
        ordered_string_of_instructions (ingredients graph) instr (n * n);;

(* testing *)

let g = parse_file "example.dot" in

print_string "Ingredients :\n";
iter (fun s -> print_string s; print_newline()) (ingredients g);

print_newline();


print_string (string_of_instructions g);;


