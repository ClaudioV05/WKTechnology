unit Controller.DeclTiposConsts;

interface

type
  TAcaoDePersistencia = (adpInclusao, adpAlteracao, adpExclusao);

type
  TRetornoPesquisa = (rpListagem, rpRegistro);

type
  TModoPesquisa = (mpComecaCom, mpContem, mpIgual);

type 
  TFormaEliminacao = (feString, feQualquer);

type TInfoConexaoSQL = record
  Database: String;
  DriverID: String;
  Password: String;
  Protocol: String;
  UserName: String;
  Server:   String;
  Port:     String;
  VendorLib: String;
end;

implementation

end.
