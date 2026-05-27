using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HelianzBusiness;

namespace UnitTestsCore.TableTypes {
	public class SessionTokenT {
		public static SessionToken CreateToken(SessionTokenType tokenType,long fkey,DateTime expiration=default) {
			SessionToken token=SessionTokens.GenerateToken(tokenType,fkey);
			if(expiration.Year > 1880) {
				token.Expiration=expiration;
				HelianzBusiness.Crud.SessionTokenCrud.Update(token);
			}
			return token;
		}
	}
}
