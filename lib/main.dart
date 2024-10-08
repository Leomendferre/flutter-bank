import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(BankApp());

class BankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bank',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: Colors.blueAccent,
        ),
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard - Flutter Bank',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 39, 76, 176),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _DashboardButton(
              icon: Icons.people,
              text: 'Contatos',
              color: Color.fromARGB(255, 236, 165, 10),
              onTap: () => _navigateTo(context, ListaContatos()),
            ),
            SizedBox(height: 8.0),
            _DashboardButton(
              icon: Icons.monetization_on,
              text: 'Transferências',
              color: const Color.fromARGB(255, 255, 59, 59),
              onTap: () => _navigateTo(context, ListaTransferencia()),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

class _DashboardButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _DashboardButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(8.0),
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(icon, size: 32.0, color: Colors.black87),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controladorCampoNumeroConta =
      TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criando Transferência',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 39, 76, 176),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
              controlador: _controladorCampoNumeroConta,
              rotulo: 'Número da Conta',
              dica: '0000',
            ),
            Editor(
                controlador: _controladorCampoValor,
                rotulo: 'Valor',
                dica: '0,00',
                icone: Icons.monetization_on),
            ElevatedButton(
              child: Text('Confirmar'),
              onPressed: () => _criaTransferencia(context),
            ),
          ],
        ),
      ),
    );
  }

  void _criaTransferencia(BuildContext context) {
    final int? numeroConta = int.tryParse(_controladorCampoNumeroConta.text);
    final double? valor =
        double.tryParse(_controladorCampoValor.text.replaceAll(',', '.'));
    if (numeroConta != null && valor != null) {
      final transferenciaCriada = Transferencia(valor, numeroConta);
      Navigator.pop(context, transferenciaCriada);
    }
  }
}

class Editor extends StatelessWidget {
  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;

  Editor({this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }
}

class ListaTransferencia extends StatefulWidget {
  final List<Transferencia> _transferencias = [];

  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciaState();
  }
}

class ListaTransferenciaState extends State<ListaTransferencia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferências - Flutter Bank',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 39, 76, 176),
      ),
      body: ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = widget._transferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push<Transferencia>(
            context,
            MaterialPageRoute(builder: (context) {
              return FormularioTransferencia();
            }),
          ).then((transferenciaRecebida) {
            if (transferenciaRecebida != null) {
              setState(() {
                widget._transferencias.add(transferenciaRecebida);
              });
            }
          });
        },
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  const ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transferencia.valorFormatado),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}

class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  String get valorFormatado {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatter.format(valor);
  }

  @override
  String toString() {
    return 'Transferencia{valor: $valor, numeroConta: $numeroConta}';
  }
}

class ListaContatos extends StatefulWidget {
  final List<Contato> _contatos = [];

  @override
  _ListaContatosState createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Contatos - Flutter Bank',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 39, 76, 176),
      ),
      body: ListView.builder(
        itemCount: widget._contatos.length,
        itemBuilder: (context, index) {
          final contato = widget._contatos[index];
          return ItemContato(contato);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push<Contato>(
            context,
            MaterialPageRoute(builder: (context) => FormularioContato()),
          ).then((contatoRecebido) {
            if (contatoRecebido != null) {
              setState(() {
                widget._contatos.add(contatoRecebido);
              });
            }
          });
        },
      ),
    );
  }
}

class ItemContato extends StatelessWidget {
  final Contato _contato;

  const ItemContato(this._contato);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text(
          'Nome: ${_contato.nome}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Endereço: ${_contato.endereco}'),
            Text('Telefone: ${_contato.telefone}'),
            Text('Email: ${_contato.email}'),
            Text('CPF: ${_contato.cpf}'),
          ],
        ),
      ),
    );
  }
}

class FormularioContato extends StatelessWidget {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Clientes - Flutter Bank',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 39, 76, 176),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _enderecoController,
              decoration: InputDecoration(labelText: 'Endereço'),
            ),
            TextField(
              controller: _telefoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _cpfController,
              decoration: InputDecoration(labelText: 'CPF'),
            ),
            ElevatedButton(
              onPressed: () {
                final contatoCriado = Contato(
                  _nomeController.text,
                  _enderecoController.text,
                  _telefoneController.text,
                  _emailController.text,
                  _cpfController.text,
                );
                Navigator.pop(context, contatoCriado);
              },
              child: Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }
}

class Contato {
  final String nome;
  final String endereco;
  final String telefone;
  final String email;
  final String cpf;

  Contato(
    this.nome,
    this.endereco,
    this.telefone,
    this.email,
    this.cpf,
  );

  @override
  String toString() {
    return 'Contato: $nome, $endereco, $telefone, $email, $cpf';
  }
}
