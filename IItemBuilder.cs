using System;
using System.Collections.Generic;
using System.Text;

namespace Theorycrafting
{

    public abstract class Item
    {
        public string slot { get; internal set; }
        public string link { get; internal set; }

        public Item(string slot, string link)
        {
            this.slot = slot;
            this.link = link;
        }

        public abstract string getItemString();
    }

    public class WeaponItem : Item
    {
        public WeaponItem(string slot, string link) : base(slot, link)
        {
        }

        public override string getItemString()
        {
            List<string> linkItems = new List<string>(link.Split(':'));
            //main_hand=,id=128935,bonus_id=744,gem_id=142518/140832/140842,relic_id=3507:1497/3516:1487:1813/3514:1477:3336  
            //off_hand=,id=128936
            string itemId = "id=" + linkItems[1];
            string offhandItem = "\r\noffhand,id=" + (int.Parse(linkItems[1]) + 1).ToString();
            int bonusCount = int.Parse(linkItems[13]);
            string bonusIds = "bonus_id=" + string.Join("/", linkItems.GetRange(14, bonusCount));
            int relicStart = 14 + bonusCount + 1;

            string relicIds = "" + string.Join("/", linkItems.GetRange(4, 3));
            string relicBonuses = getRelicBonuses(linkItems.GetRange(relicStart, linkItems.Count - relicStart));

            return string.Join(",", new List<string>()
            {
                "main_hand=",
                itemId,
                bonusIds,
                relicIds,
                relicBonuses
            }) + offhandItem;
        }

        private string getRelicBonuses(List<string> relicBonusSegments)
        //gem_id=142518/140832/140842,relic_id=3507:1497/3516:1487:1813/3514:1477:3336  
        {
            string relicBonuses = "relic_id=";
            int offset = 0;
            for (int i = 0; i < 3; i++)
            {
                int bonusCount = int.Parse(relicBonusSegments[offset]);
                offset += 1;
                relicBonuses += string.Join(":", relicBonusSegments.GetRange(offset, bonusCount));
                offset += bonusCount;
                relicBonuses += "/";
            }
            return relicBonuses.TrimEnd('/');
        }
    }

    public class NonWeaponItem : Item
    {
        public NonWeaponItem(string slot, string link) : base(slot, link)
        {
        }

        public override string getItemString()
        {
            List<string> linkItems = new List<string>(link.Split(':'));
            //back=,id=140910,bonus_id=3516/1492/3336,enchant=190879

            string itemId = "id=" + linkItems[1];

            int bonusCount = int.Parse(linkItems[13]);
            string bonusIds = "bonus_id=" + string.Join("/", linkItems.GetRange(14, bonusCount));

            return string.Join(",", new List<string>()
            {
                GetSlot(),
                itemId,
                bonusIds
            });

        }

        private string GetSlot()
        {
            return slot.Replace("INVTYPE_", "")
                       .Replace("CLOAK", "BACK")
                       .Replace("CHEST", "ROBE")
                       .ToLower();
        }
    }

    public class ItemFactory
    {
        public static Item getItem(string slot, string link)
        {
            if (slot.Equals("INVTYPE_WEAPONMAINHAND"))
            {
                return new WeaponItem(slot, link);
            }
            else
            {
                return new NonWeaponItem(slot, link);
            }
        }
    }
}
