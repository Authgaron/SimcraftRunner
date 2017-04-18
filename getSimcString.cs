using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using Theorycrafting;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlString getSimcString(SqlString link, SqlString slot)
    {
        string trimmedLink = link.Value.Replace("\\124", "|").Split('|')[1].Split(':')[1];

        Item item = ItemFactory.getItem(slot.ToString(), trimmedLink);

        return item.getItemString();
    }
}
