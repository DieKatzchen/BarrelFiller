{
  Container Filler 0.1
  By DieKatzchen
  

  Takes a selected list of items and places them inside a selected container

}
unit userscript;
var
  slItems: TStringList;
  slContainers: Array[0..20] of IInterface;
  cntCount: int;
  
function CountBox: string;
var 
  frm: TForm;
  btnOK, btnCancel: TButton;
  boxCount: TEdit;
  
begin;
  frm := TForm.Create(frm);
  try
    frm.Caption := 'How Many?';
    frm.Width := 300;
    frm.Height := 200;
    frm.Position := poScreenCenter;
	
	boxCount := TEdit.Create(frm);
    boxCount.Parent := frm;
    boxCount.Top := 40;
    boxCount.Left := 120;
    boxCount.Width := 40;
	boxCount.Alignment := taCenter;

	btnOk := TButton.Create(frm);
    btnOk.Parent := frm;
    btnOk.Left := 60;
    btnOk.Top := boxCount.Top + 50;
    btnOk.Caption := 'OK';
    btnOk.ModalResult := mrOk;

	btnCancel := TButton.Create(frm);
    btnCancel.Parent := frm;
    btnCancel.Caption := 'Cancel';
    btnCancel.ModalResult := mrCancel;
    btnCancel.Left := btnOk.Left + btnOk.Width + 16;
    btnCancel.Top := btnOk.Top;
	
	if frm.ShowModal = mrOk
	  then result := boxCount.Text;
  finally
    frm.Free;
  end;
end;

// Called before processing
// You can remove it if script doesn't require initialization code
function Initialize: integer;
var
  i: integer;
begin
  Result := 0;
  
  //  initialize stringlists
  slItems := TStringList.Create;
  cntCount := 0;
  For i := 1 to 20 do
    slContainers[i]  := 0;
end;

// called for every record selected in xEdit
function Process(e: IInterface): integer;
var
  s: string;
begin
  Result := 0;
  s := GetFileName(e);
  // comment this out if you don't want those messages
  //AddMessage('Processing: ' + Name(e));
  if (Signature(e) = 'CONT') then
    begin
      //AddMessage('Container');
      slContainers[cntCount] := e;
	  Inc(cntCount);
    end
  else
    begin
      //AddMessage('Item');
      slItems.Add(GetEditValue(e));
    end;
end;

// Called after processing
// You can remove it if script doesn't require finalization code
function Finalize: integer;
var
  count: string;
  itemcount, i, j: integer;
  cnto, item, items: IInterface;
begin
  if cntCount < 1 then
  begin
    AddMessage('Select at least 1 container!  Terminating script.');
    slItems.Free;
    //slContainers.Free;
    Exit;
  end;
  if slItems.Count < 1 then
  begin
    AddMessage('Select at least 1 item!  Terminating script.');
    slItems.Free;
    //slContainers.Free;
    Exit;
  end;
  itemcount := 0;
  count := CountBox;
  if count < 1 then
  begin
    AddMessage('Add at least 1 item!  Terminating script.');
    slItems.Free;
    slContainers.Free;
    Exit;
  end;
  for i := 0 to cntCount - 1 do
  begin
	if (ElementExists(slContainers[i], 'Items')) then
	begin
	  items := ElementByName(slContainers[i], 'Items');
	  Inc(itemcount);
	end
	else
	begin
      items := Add(slContainers[i], 'Items', True);
	end;
	for j := 0 to slItems.Count - 1 do
	begin
	  if (itemcount < 1) then
	  begin;
	    item := ElementByName(items, 'Item');
		Inc(itemcount);
      end
	  else
        item := ElementAssign(items, HighInteger, nil, False);
	  cnto := ElementBySignature(item, 'CNTO');
      SetElementEditValues(cnto, 'Item', slItems[i]);
      SetElementEditValues(cnto, 'Count', count);
    end;
  end
end;

end.
