unit UParam;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs;

type
    PNotifyEvent = ^TNotifyEvent;
    TNotifyEvents = class(TObject)
    private
        fList: TList;
        function getItems(Index: Integer): PNotifyEvent;
    public
        constructor Create;
        destructor Destroy; override;
        procedure Add(aEvent: TNotifyEvent);
        procedure Change(Sender: TObject);
        property Items[Index: Integer]: PNotifyEvent read getItems; default;
    end;

    TParam = class(TObject)
    private
        fEvents: TNotifyEvents;
        fIndexOfIntervalRefresh: Integer;
        flock: Integer;
        ftrayOnMinimize: Boolean;
        procedure setIndexOfIntervalRefresh(const Value: Integer);
        procedure settrayOnMinimize(Value: Boolean);
    public
        constructor Create;
        destructor Destroy; override;
        procedure beginChange;
        procedure change;
        procedure endChange(doChangeOnUnlock: Boolean = true);
        procedure initDefault;
        procedure OnChange(aEvent: TNotifyEvent);
        property IndexOfIntervalRefresh: Integer read fIndexOfIntervalRefresh
            write setIndexOfIntervalRefresh;
        property trayOnMinimize: Boolean read ftrayOnMinimize write
            settrayOnMinimize;
    end;

var
    param:TParam;

implementation

{
******************************** TNotifyEvents *********************************
}
constructor TNotifyEvents.Create;
begin
    inherited Create;
    fList:=TList.Create;
end;

destructor TNotifyEvents.Destroy;
var
    i: Integer;
    P: PNotifyEvent;
begin
    for i:=0 to fList.Count - 1 do begin
        P:=Items[i];
        Dispose(P);
    end;
    fList.Free;
    inherited Destroy;
end;

procedure TNotifyEvents.Add(aEvent: TNotifyEvent);
var
    P: PNotifyEvent;
begin
    New(P);
    P^:=aEvent;
    fList.Add(P);
end;

procedure TNotifyEvents.Change(Sender: TObject);
var
    i: Integer;
    cEvent: TNotifyEvent;
begin
    for i:=0 to fList.Count - 1 do begin
        try
        try
            cEvent := (Items[i])^;
            if Assigned(cEvent) then
                cEvent(sender);

        except
        on e:Exception do
        begin

        end;
        end;
        finally

        end;
    end;
end;

function TNotifyEvents.getItems(Index: Integer): PNotifyEvent;
begin
    result:=PNotifyEvent(fList.Items[Index]);
end;

{
************************************ TParam ************************************
}
constructor TParam.Create;
begin
    inherited Create;
    flock:=0;
    fEvents:=TNotifyEvents.Create();
end;

destructor TParam.Destroy;
begin
    fEvents.Free;
    inherited Destroy;
end;

procedure TParam.beginChange;
begin
    flock:=flock+1;
end;

procedure TParam.change;
begin
    if ( (flock = 0) ) then
        fEvents.change(self);
end;

procedure TParam.endChange(doChangeOnUnlock: Boolean = true);
begin
    flock:=flock-1;

    if ( flock = 0 ) and (doChangeOnUnlock) then
        change();
end;

procedure TParam.initDefault;
begin
    beginChange();
    try try

        fIndexOfIntervalRefresh:=2;
        fTrayOnMinimize:=true;

    except on e:Exception do begin
    end;end;
    finally

    endChange();

    end;
end;

procedure TParam.OnChange(aEvent: TNotifyEvent);
begin
    fEvents.Add(aEvent);
end;

procedure TParam.setIndexOfIntervalRefresh(const Value: Integer);
begin
    if fIndexOfIntervalRefresh <> Value then
    begin
        fIndexOfIntervalRefresh := Value;
        change();
    end;
end;

procedure TParam.settrayOnMinimize(Value: Boolean);
begin
    if ftrayOnMinimize <> Value then
    begin
        ftrayOnMinimize := Value;
        change();
    end;
end;

end.