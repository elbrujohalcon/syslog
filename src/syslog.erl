-module(syslog).

-behaviour(gen_server).

% API
-export([
	start_link/0,
	log/1,
	log/2
]).

% gen_server callbacks
-export([
	init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3
]).

-record(state,{}).

-define(LOG_EMERG  , 0). %% system is unusable
-define(LOG_ALERT  , 1). %% action must be taken immediately
-define(LOG_CRIT   , 2). %% critical conditions
-define(LOG_ERR    , 3). %% error conditions
-define(LOG_WARNING, 4). %% warning conditions
-define(LOG_NOTICE , 5). %% normal, but significant, condition
-define(LOG_INFO   , 6). %% informational message
-define(LOG_DEBUG  , 7). %% debug-level message

-define(DEFAULT_PRIORITY, ?LOG_WARNING).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

log(Priority, Message) ->
	gen_server:cast(?MODULE, {log, Priority, Message}).

log(Message) ->
	gen_server:cast(?MODULE, {log, ?DEFAULT_PRIORITY, Message}).

%%% API %%%

init([]) ->
  erlang:load_nif("priv/syslog_drv", 0),
  {ok, #state{}}.


handle_call(_Msg, _From, State) ->
	{reply, ok, State}.

handle_cast({log, Priority, Message}, #state{} = State) ->
  slog(Priority,lists:flatten(Message)),
	{noreply, State};

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_, _, _) ->
	ok.

slog(_Priority, _Message) -> 
  {error, nif_not_loaded}.

