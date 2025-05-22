import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";

actor {

  type Tarefa = {
    id : Nat;
    categoria : Text;
    descricao : Text;
    urgente : Bool;
    concluida : Bool;
  };

  
  var idTarefa : Nat = 0;

  var tarefas : Buffer.Buffer<Tarefa> = Buffer.Buffer<Tarefa>(10);

  public func addTarefa(desc : Text, cat : Text, urg : Bool, con : Bool) : async () {
    idTarefa += 1; 
    let t : Tarefa = {
      id = idTarefa;
      categoria = cat;
      descricao = desc;
      urgente = urg;
      concluida = con;
    };
    tarefas.add(t);
  };

  public func excluirTarefa(idExcluir : Nat) : async () {

    func localizaExcluir(i : Nat, x : Tarefa) : Bool {
      return x.id != idExcluir;
    };

    tarefas.filterEntries(localizaExcluir);

  };

  public func alterarTarefa(idTar : Nat, cat : Text, desc : Text, urg : Bool, con : Bool) : async () {

    let t : Tarefa = {
      id = idTar;
      categoria = cat;
      descricao = desc;
      urgente = urg;
      concluida = con;
    };

    func localizaIndex(x : Tarefa, y : Tarefa) : Bool {
      return x.id == y.id;
    };

    let index : ?Nat = Buffer.indexOf(t, tarefas, localizaIndex);

    switch (index) {
      case (null) {
        // não foi localizado um index
      };
      case (?i) {
        tarefas.put(i, t);
      };
    };

  };

  public func getTarefas() : async [Tarefa] {
    return Buffer.toArray(tarefas);
  };

  public func totalTarefasConcluidas() : async Nat {
    var countCompletedTasks = 0;

    for (tarefa in tarefas.vals()){
      if(tarefa.concluida == true){
        countCompletedTasks += 1;
      }
    };

    return countCompletedTasks;
  };
};
