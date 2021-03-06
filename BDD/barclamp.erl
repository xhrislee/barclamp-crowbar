% Copyright 2012, Dell 
% 
% Licensed under the Apache License, Version 2.0 (the "License"); 
% you may not use this file except in compliance with the License. 
% You may obtain a copy of the License at 
% 
%  http://www.apache.org/licenses/LICENSE-2.0 
% 
% Unless required by applicable law or agreed to in writing, software 
% distributed under the License is distributed on an "AS IS" BASIS, 
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
% See the License for the specific language governing permissions and 
% limitations under the License. 
% 
% 
-module(barclamp).
-export([step/3, json/3, validate/1, inspector/1, g/1]).
-include("bdd.hrl").

% Commont Routine
% Provide Feature scoped strings to DRY the code
g(Item) ->
  case Item of
    path -> "api/v2/barclamps";
    name -> "bddbarclamp";
    atom -> barclamp1;
    _ -> crowbar:g(Item)
  end.
  
% Common Routine
% Makes sure that the JSON conforms to expectations (only tests deltas)
validate(JSON) ->
  Wrapper = crowbar_rest:api_wrapper(JSON),
  J = Wrapper#item.data,
  R =[Wrapper#item.type == barclamp,
      bdd_utils:is_a(J, boolean, user_managed), 
      bdd_utils:is_a(J, number, layout), 
      bdd_utils:is_a(J, boolean, allow_multiple_deployments), 
      bdd_utils:is_a(J, number, proposal_schema_version), 
      bdd_utils:is_a(J, number, jig_order), 
      % invalid test bdd_utils:is_a(J, string, transitions), 
      bdd_utils:is_a(J, string, mode), 
      % invalid test bdd_utils:is_a(J, string, transition_list), 
      bdd_utils:is_a(J, number, run_order), 
      bdd_utils:is_a(J, string, display), 
      bdd_utils:is_a(J, string, commit), 
      bdd_utils:is_a(J, string, source_path), 
      bdd_utils:is_a(J, number, version), 
      crowbar_rest:validate(J)],
  bdd_utils:assert(R, debug). 

% Common Routine
% Creates JSON used for POST/PUT requests
json(Name, Description, Order) ->
  json:output([{"name",Name},{"description", Description},{"order", Order}]).

% Common Routine
% Returns list of nodes in the system to check for bad housekeeping
inspector(Config) -> 
  crowbar_rest:inspector(Config, barclamp).  % shared inspector works here, but may not always

step(Config, _Global, {step_setup, _N, _}) -> Config;

step(Config, _Global, {step_teardown, _N, _}) -> Config.
