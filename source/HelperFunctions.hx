import sys.FileSystem;

class HelperFunctions
{
    public static function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
	}

	public static function vocalExists(song:String):Bool
	{
		if (FileSystem.exists('assets/songs/' + song.toLowerCase() + '/Voices.ogg'))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
}