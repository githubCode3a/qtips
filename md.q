/ empty tables
ref:.util.sattr 1!flip `id`px`ts`qs`vol`rfr!"jffjff"$\:()
prices:.util.sattr flip `id`px`time!"jfn"$\:()
price:.util.sattr 1!prices
trades:.util.sattr flip `id`ts`tp`time!"jjfn"$\:()
trade:.util.sattr 1!trades
quotes:.util.sattr flip `id`bs`bp`ap`as`time!"jjffjn"$\:()
quote:.util.sattr 1!quotes

\d .md

/ update the current price for id
updp:{[id;tm]
 .log.inf "updating price for ", string id;
 p:`price id;
 r:`ref id;
 z:.stat.norminv rand 1f;
 f:.stat.gbm[r `vol;r `rfr;((tm:"n"$tm)-p `time)%365D06;z];
 p:`id`px`time!(id;f*p `px;tm);
 `price`prices upsert\: p;
 }

/ update the current quote for id
updq:{[id;tm]
 .log.inf "updating quote for ", string id;
 px:`price[id;`px];
 r:`ref id;
 q:`id`time!(id;"n"$tm);
 q,:`bp`ap!.sim.tickrnd[r `ts] px;
 q,:`bs`as!2#1+rand r `qs;
 `quote`quotes upsert\: q;
 }

/ update the current trade price for id
updt:{[id;tm]
 if[not id in key `quote;:(::)];
 .log.inf "updating trade for ", string id;
 q:`quote id;
 t:`id`time!(id;"n"$tm);
 t,:`ts`tp!.sim.trd[rand 01b;rand 1f] . q `bs`bp`ap`as;
 `trade`trades upsert\: t;
 }

/ dump all md.q tables in partitioned database format
dump:{[db;tm]
 dt:"d"$tm;
 .log.inf "dumping tables in ", 1_ string ` sv db,`$string dt;
 .Q.dpft[db;dt;`id] each `prices`quotes`trades;
 }
 