// Copyright (c) 2019 Racyics GmbH,  All rights reserved
// This file contains confidential and proprietary information of Racyics GmbH.
// The content may not be disclosed, copied or modified without written permission by Racyics GmbH.
// All content is provided "as is".
// The content is subject to change by Racyics GmbH at any time without notice.
// Racyics GmbH disclaims all warranties.
// -----------------------------------------------------------------------
// Description       :   ri_common cell to be used for
//                       hard instantiated clock buffer
// -----------------------------------------------------------------------
module common_clkbuf (  
    I,
    Z
);

    input  I;

    output Z;

    wire   Z;

    assign Z = I;

endmodule
